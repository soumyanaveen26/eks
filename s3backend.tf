terraform {
  backend "s3" {
    bucket = "eksterraformstatefile-01"
    key    = "eksterraformstatefile"
    region = "us-east-1"
  }
}
