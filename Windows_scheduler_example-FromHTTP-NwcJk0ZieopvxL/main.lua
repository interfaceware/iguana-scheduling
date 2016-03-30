-- This script gives an example of invoking the windows scheduler.
-- We write out a batch file and invoke it with the scheduler.
--
-- The main motivation for this was to be able to invoke something which
-- runs outside of Iguana for the upgrade utility we have been working on
--
-- But this channel shows a stand along version of it.

-- The require returns a single function which we call ScheduleTask
local ScheduleTask = require 'windows.scheduler'

local Template=[[
<html><body>
<p>This just activated this batch script:</p>
<pre>
#SCRIPT#
</pre>
<p>This should put some stuff into #LOGFILE#.</p>
<p>This is the result that came back from the windows scheduler:</p>

<pre>#RESULT#</pre>

<p>Chances are you'll need to edit the script to put in a valid user and
password for a windows user with the right permissions to schedule the task.</p>

<p>Good luck!</p>
</body></html>
]]

local Command=[[
time /t >> iguanatest.log
echo Right on - the script from Iguana ran! >> iguanatest.log
]]

local function WriteFile(Name, Content)
   local F = io.open(Name, "w")
   F:write(Content)
   F:close()
end

function main(Data)
   local LogFile = os.getenv('TEMP').."\\iguanatest.log"
   -- Write out a batch file
   WriteFile(os.getenv('TEMP').."\\run_iguana_test.bat", Command)
   
   local ResultOut = ScheduleTask{command="run_iguana_test.bat",
      working_dir=os.getenv('TEMP')..'\\', user="cow", password="moo"}
 
   local Body = Template:gsub("#LOGFILE#", LogFile)
   Body = Body:gsub("#RESULT#", ResultOut);
   Body = Body:gsub("#SCRIPT#", Command);    
  
   net.http.respond{body=Body}
end