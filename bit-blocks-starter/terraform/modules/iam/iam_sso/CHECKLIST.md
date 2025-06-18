# 🔐 AWS Identity Center Setup – External IdP Integration Checklist

Use this checklist to integrate AWS Identity Center (SSO) with your external IdP (Google Workspace, Azure AD, Okta) for Booster Pack automation.

---

## ✅ 1. Pre-Setup Requirements

- [ ] AWS Organization is enabled  
- [ ] AWS Identity Center is enabled (one per Org)  
- [ ] You have Admin access in AWS and the IdP  
- [ ] Terraform CLI is installed  
- [ ] Booster Pack is cloned  
- [ ] You have your `identity_center_instance_arn` from AWS

---

## ✅ 2. Configure the External Identity Provider

### 🔹 Google Workspace

- [ ] Go to **Admin Console → Apps → Web and mobile apps**
- [ ] Click **Add App → Custom SAML App**
- [ ] Upload AWS metadata file (from AWS Identity Center)
- [ ] Set Attributes:
  - `email` → Primary email
  - `firstName`, `lastName`, `displayName`
- [ ] Enable SCIM Provisioning
  - Go to AWS → Identity Center → Settings → SCIM
  - Copy SCIM Endpoint + Token
  - Paste in Google Admin SCIM section

---

### 🔹 Azure AD

- [ ] Azure Portal → Azure AD → Enterprise Applications → New Application
- [ ] Choose AWS IAM Identity Center
- [ ] Configure SAML with metadata file or manually
- [ ] Set SAML claims:
  - `email`, `firstName`, `lastName`, etc.
- [ ] Enable SCIM:
  - Go to **Provisioning > Automatic**
  - Add SCIM Endpoint and Token from AWS
- [ ] Save and Test user/group sync

---

## ✅ 3. Get Group UUIDs from AWS

- [ ] AWS Console → Identity Center → Groups
- [ ] Copy each Group’s UUID (e.g. `08abc123de456fghijk`)
- [ ] Paste these into your `groups.yaml` file

---

## ✅ 4. Define Groups in YAML

Sample `groups.yaml`:

```yaml
groups:
  - name: DevOps
    id: 08abc123de456fghijk
    permission_set: AdminAccess
    account_ids:
      - "111122223333"
      - "444455556666"
```