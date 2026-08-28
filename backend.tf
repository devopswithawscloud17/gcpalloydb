terraform {
  backend "gcs" {
    bucket = "gcppsterraform"
    prefix = "alloydb/dev"
  }
}
