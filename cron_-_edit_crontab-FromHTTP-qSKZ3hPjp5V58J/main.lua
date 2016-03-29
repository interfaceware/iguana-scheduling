-- Simple example show programmatically reading and writing from the crontab file.

local cron = require 'cron.edit'

local Template=[[
<html>
<body>
<p>
This is the crontab for this user.  If you refresh the script it will add and remove a comment in the crontab.
Thus this shows how one can use Iguana to programmatically alter the crontab file for the user that Iguana is running under.
</p>
<pre>
#CRONTAB#
</pre>
</body>
</html>
]]

function main(Data)
   local Content = cron.read()
   local Comment = "# This comment was added by Iguana"
   if not Content:find(Comment) then
      Content = Content..Comment
      cron.write(Content)
   else
      Content = Content:gsub(Comment, '')
      cron.write(Content)
   end

   trace(Content)   
   net.http.respond{body=Template:gsub("#CRONTAB#", Content)}
end