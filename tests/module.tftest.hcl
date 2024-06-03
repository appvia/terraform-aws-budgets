mock_provider "aws" {}

run "basic" {
  command = plan

  module {
    source = "./modules/team-budgets"
  }
}
