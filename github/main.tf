terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/* Github */

provider "github" {
  organization = "${var.github_owner}"
  token        = "${var.github_oauth_token}"
}


/* Starcity Engineering Team */

resource "github_team" "engineering" {
  name        = "starcity-engineering-team"
  description = "Some cool team upstairs..."
  privacy     = "closed"
}


resource "github_team_membership" "team_member" {
  count = "${length(var.github_ssh_keys)}"

  username = "${lookup(var.github_ssh_keys[count.index], "username")}"
  team_id  = "${github_team.engineering.id}"
  role     = "member"
}


resource "github_user_ssh_key" "engineer" {
  count = "${length(var.github_ssh_keys)}"

  title = "${lookup(var.github_ssh_keys[count.index], "username")}:starcity-engineer"
  key   = "${lookup(var.github_ssh_keys[count.index], "ssh_key")}"
}
