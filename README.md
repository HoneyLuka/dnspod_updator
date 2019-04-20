# dnspod_updator

A ruby script for update dnspod ddns record.

## Requirements

- Ruby (>= 2.0.0)

## Preparation

Before using the script, you need to fill in your dnspod information into the file.

```ruby
$params = {
    'login_token' => '#{REPLACE_ME}',
    'format' => 'json',
    'domain' => '#{REPLACE_ME}',
    'record_id' => '#{REPLACE_ME}',
}

$sub_domain = 'www'
```

- **login_token:** You can get login_token from <a href="https://www.dnspod.cn/console/user/security">**here**</a>. **NOTE THAT** login_token format is **'ID,Token'**. For more information about <a href="https://support.dnspod.cn/Kb/showarticle/tsid/227/">**login_token**</a>.
  
- **domain**: Which domain you want to modify. You can get **domain_id** by API **Domain.List**
  
- **record_id**: Which record you want to modify. You can get **record_id** by API **Record.List**

- **sub_domain**: Set sub domain

## Usage

```bash
ruby dnspod_updator.rb
```

You can set a schedule task on your NAS to update ip automatically.