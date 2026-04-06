# Online Voting System Spec Checklist

Stack note: the current UI uses Tailwind CSS instead of Bootstrap by project choice.

## Core Requirements

| Requirement | Status | Notes |
| --- | --- | --- |
| Session-based online voting system | Implemented | Servlet/JSP flow with `HttpSession`-based auth |
| Voter registration | Implemented | First name, last name, email, password, state, country, and birth date/year persistence |
| Password hashing | Implemented | BCrypt used for registration, login validation, reset, and password change |
| Email verification before login | Implemented | OTP generation, resend, and verification flow |
| Authenticated dashboard access only | Implemented | Protected via auth filters |
| One vote per voter | Implemented | Enforced in application logic and DB unique constraint |
| View contesters and their positions | Implemented | Candidate list groups approved contesters by position |
| View vote counts per contester | Implemented | Read-only results page and admin results page |
| Contester self-vote once | Implemented | Only approved contesters can self-vote once |
| Profile management | Partial | Update profile and change password are present; delete-account flow is not included |
| Home / About / Contact pages | Implemented | Public-facing pages exist |
| Predefined positions using enum | Implemented | `Position` enum used in registration and admin views |
| Max 3 approved contesters per position | Implemented | Checked on registration and admin approval |
| Admin views voters and contesters | Implemented | User management and contester management pages |
| Admin approves / denies contesters | Implemented | Admin status endpoint and management page |
| Admin monitors votes / activity | Implemented | Results, dashboard metrics, and audit logs |
| Role-based access control | Implemented | Admin, voter, and contester route restrictions |
| SQL injection protection | Implemented | JPA queries used throughout |

## Recommended Enhancements

| Enhancement | Status | Notes |
| --- | --- | --- |
| Forgot password with secure token | Implemented | Reset token email flow exists |
| Voting deadline control | Implemented | Admin can open/close voting and set deadline |
| Audit logs for admin actions | Implemented | Admin audit log entity and views exist |
| Pagination for voter / contester lists | Missing | Admin list pages still load full result sets |

## Project-Specific Additions

| Feature | Status | Notes |
| --- | --- | --- |
| Contester manifesto | Implemented | Contesters submit once; admins can review it |
| Admin suspend user | Implemented | Added to user management |
| Admin delete user | Implemented | Added with cleanup of related records |
