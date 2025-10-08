// FindMain.ql
import cpp  

from Function f
where f.hasGlobalName("main")
select f, "This is the main function."