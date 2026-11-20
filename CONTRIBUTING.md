# Branching Policy

- `main` is protected and always deployable. No direct pushes.
- Create one branch per change from `main`, named `feature/<short-description>`.
- Open a pull request into `main`. It needs:
  - a passing **Terraform CI** check (`terraform fmt` and `terraform validate`)
  - at least one approving review
- Merge after approval, then delete the feature branch.
