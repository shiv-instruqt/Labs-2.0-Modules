# -----------------------------------------------------------------------------
# Lab-level inputs. Change a default here and every module that receives it
# picks up the new value on the next session.
# -----------------------------------------------------------------------------

variable "blue_version" {
  default     = "1.0.0"
  description = "Version served by the blue instance (the current release)."
}

variable "green_version" {
  default     = "2.0.0"
  description = "Version served by the green instance (the new release)."
}

variable "live_color" {
  default     = "blue"
  description = "Instance that receives traffic when a session starts. The lab's tasks assume blue."
}

variable "hotfix_version" {
  default     = "2.0.1"
  description = "Version learners roll out to green in the hotfix task."
}
