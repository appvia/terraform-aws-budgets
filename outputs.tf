output "budget_arns" {
  description = "Map of budget names to budget ARNs"
  value       = { for name, budget in aws_budgets_budget.this : name => budget.arn }
}

output "budget_ids" {
  description = "Map of budget names to budget IDs"
  value       = { for name, budget in aws_budgets_budget.this : name => budget.id }
}

output "budget_names" {
  description = "List of created budget names"
  value       = sort(keys(aws_budgets_budget.this))
}
