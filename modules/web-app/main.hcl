# -----------------------------------------------------------------------------
# web-app module: RESOURCES
#
# One nginx container that serves a coloured homepage and a /version.txt file.
# The lab uses this module twice (blue and green). Every resource in here is
# namespaced by the module block that uses it, so two copies never collide.
#
# Note: this module deliberately contains no file paths. Its start-up script is
# inline, so the module is fully self-contained and portable.
# -----------------------------------------------------------------------------

resource "container" "web" {
  image {
    name = "nginx:1.27"
  }

  # Values flow from module inputs -> environment -> start-up script.
  environment = {
    APP_NAME    = variable.name
    APP_VERSION = variable.version
    APP_COLOR   = variable.accent_color
  }

  # Write the site content from the environment, then run nginx in the
  # foreground so it stays PID 1 (learners can still run `nginx -s reload`).
  command = [
    "/bin/bash",
    "-c",
    <<-EOT
      set -e
      mkdir -p /usr/share/nginx/html
      cat > /usr/share/nginx/html/index.html <<HTML
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <title>$APP_NAME $APP_VERSION</title>
          <style>
            body { margin: 0; min-height: 100vh; display: grid; place-items: center;
                   background: $APP_COLOR; color: #fff; font-family: system-ui, sans-serif; }
            main { text-align: center; }
            h1   { font-size: 3rem; margin: 0 0 .5rem; text-transform: uppercase; letter-spacing: .1em; }
            p    { font-size: 1.25rem; margin: .25rem 0; opacity: .9; }
          </style>
        </head>
        <body>
          <main>
            <h1>$APP_NAME</h1>
            <p>version $APP_VERSION</p>
            <p>served by $(hostname)</p>
          </main>
        </body>
      </html>
      HTML
      echo "$APP_NAME $APP_VERSION" > /usr/share/nginx/html/version.txt
      exec nginx -g 'daemon off;'
    EOT
  ]

  port {
    local = 80
  }

  resources {
    cpu    = 250
    memory = 256
  }

  network {
    id         = variable.network_id
    ip_address = variable.ip_address
    aliases    = [variable.name]
  }
}
