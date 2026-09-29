# -----------------------------------------------------------------------------
# Tasks. Script paths resolve from the lab root. TEST VARIANT (no modules):
# task targets are the lab's own containers.
# -----------------------------------------------------------------------------

# Chapter 2, page 1: find out which instance is live.
resource "task" "identify_live" {
  description     = "Find out which instance is serving live traffic and record it."
  success_message = "Correct. Blue is live and green is on standby, ready for the release."

  config {
    target  = resource.container.lb
    timeout = "15s"

    environment = {
      EXPECTED_COLOR = variable.live_color
    }
  }

  condition "answer_file_exists" {
    description = "/root/live-color.txt exists"

    check {
      script          = "scripts/task/identify_live/check_file.sh"
      failure_message = "The file /root/live-color.txt does not exist yet."
    }

    solve {
      script = "scripts/task/identify_live/solve.sh"
    }
  }

  condition "answer_is_correct" {
    description = "/root/live-color.txt names the live instance"

    check {
      script          = "scripts/task/identify_live/check_answer.sh"
      failure_message = "That is not the instance serving traffic. Run curl -s localhost/version.txt on the load balancer and write only the name (for example blue)."
    }

    solve {
      script = "scripts/task/identify_live/solve.sh"
    }
  }
}

# Chapter 2, page 2: cut traffic over from blue to green.
resource "task" "switch_to_green" {
  description     = "Point the load balancer at green and reload nginx without downtime."
  success_message = "Traffic is now on green 2.0.0. Blue is still running, so rollback is one line away."

  config {
    target  = resource.container.lb
    timeout = "20s"
  }

  condition "config_points_to_green" {
    description = "The nginx config sends traffic to the green upstream and passes nginx -t"

    check {
      script          = "scripts/task/switch_to_green/check_config.sh"
      failure_message = "default.conf still does not contain 'proxy_pass http://green;', or nginx -t reports an error."
    }

    solve {
      script = "scripts/task/switch_to_green/solve.sh"
    }
  }

  condition "traffic_on_green" {
    description = "Requests through the load balancer are answered by green"

    check {
      script          = "scripts/task/switch_to_green/check_traffic.sh"
      failure_message = "The load balancer is still answering from blue. Did you run nginx -s reload?"
    }

    solve {
      script = "scripts/task/switch_to_green/solve.sh"
    }
  }
}

# Chapter 2, page 3: patch green in place and prove the fix is live.
# One task, two targets: each condition overrides the task-level target.
resource "task" "hotfix_green" {
  description     = "Ship a hotfix to green and confirm that users receive it through the load balancer."
  success_message = "Hotfix is live. You changed one module instance and left the other untouched."

  config {
    target  = resource.container.green
    timeout = "15s"

    environment = {
      HOTFIX_VERSION = variable.hotfix_version
    }
  }

  condition "green_patched" {
    description = "green serves the hotfix version in /version.txt"

    check {
      script          = "scripts/task/hotfix_green/check_green.sh"
      failure_message = "On the Green shell, /usr/share/nginx/html/version.txt should read exactly: green 2.0.1"
    }

    solve {
      script = "scripts/task/hotfix_green/solve.sh"
    }
  }

  condition "hotfix_is_live" {
    description = "The load balancer serves the hotfix to users"

    config {
      target = resource.container.lb
    }

    check {
      script          = "scripts/task/hotfix_green/check_live.sh"
      failure_message = "Users are not getting green 2.0.1 yet. Check that traffic still goes to green."
    }

    # Skipping this condition makes sure traffic goes to green.
    solve {
      script = "scripts/task/switch_to_green/solve.sh"
    }
  }
}
