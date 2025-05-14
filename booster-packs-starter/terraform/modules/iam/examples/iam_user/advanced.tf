module "john_doe_user_details" {
    source = "../terraform-modules/iam/iam_user"
    user_name = "John_Doe"
    user_path = "/users/john_doe/"
    create_login_profile = true
    create_access_key = true
    pgp_key = "keybase:or4dx"
    password_length = 16
    password_reset_required = false
    enable_access_analyzer = false
    enable_scp = false
    enable_cloudtrail = false
    iam_groups = ["Administrators"]
    environment = "global"
        tags = {
                Name = "John Doe"
    }
}