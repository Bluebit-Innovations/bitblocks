module "john_doe_user_details" {
    source      = "../terraform-modules/iam/iam_user"
    user_name   = "John_Doe"
    user_path   = "/users/john_doe/"
    iam_groups  = ["Administrators"]
    environment = "global"
    tags = {
        Name = "John Doe"
    }
}
