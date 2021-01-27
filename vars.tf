variable "project" {
  default = "check-point-project"
}
variable "templName" {
  default = "check-point-r8030-gw-byol-single"
}

variable "templVer" {
  default = "273-687-v20200924"
}

variable "instPref" {
  default = "gw"
}
variable "Ginstype"{
  type = map(string)
  default = {
    gw = "Gateway only"
    mgmt = "Management only"
    standalone = "Gateway and Management (Standalone)"
    manual = "Manual Configuration"
  }
}
variable "proj_region" {
  default = "us-central1"
}
variable "proj_zone" {
  default = "us-central1-a"
}
variable "machinetype" {
  default = "n1-standard-2"
}
variable "canipfwd" {
  default = true
}
variable "gtags" {
  default = ["GATEWAY","UID"]
}
variable "gwname" {
  default = "tfcggw"
}
variable "adminpwd" {
  default = "CpWins$1!"
}
variable "ssh_pub_key_file" {
  default = "/root/.ssh/id_rsa.pub"
}
variable "sickey" {
  default = "qwe123456"
}
variable "allowupdown" {
  default = true
}
variable "eth2_nw" {
  default = "10.10.0.0/24"
}
variable "eth3_nw" {
  default = "10.11.0.0/24"
}
variable "enablMon" {
  default = false
}
variable "svc_accnt_email" {
  default = "111111111111-compute@developer.gserviceaccount.com"
}
variable "genpasswd" {
  default = false
}
