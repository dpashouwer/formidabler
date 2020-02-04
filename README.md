# formidabler
Programmatic access to Fromidable forms (&lt;https://formidableforms.com/>)

# example
``` R
site_name = [enter site name]
form_number = [enter form number]
my_username = [enter Wordpress username]
my_password = [enter Wordpress password]

entries <- formidabler::pull_entries(url = paste0(site_name, "/wp-json/frm/v2/forms/", form_number, "/"),
                                       my_username = my_username,
                                       my_password = my_password)

entries
```
