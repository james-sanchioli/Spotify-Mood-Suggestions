suppressPackageStartupMessages(source("shared_library.R"))

user_library = get_user_library_df()

name = get_my_profile()$display_name
filename = paste0("Reports/user_library_", str_replace_all(tolower(name), " ", "_"), ".csv")

dir.create("Reports", showWarnings = FALSE)
write.csv(user_library, filename)
message(paste0("\nCreated report for the user ", name, " in '", filename, "'\n"))
