public isolated service class TodoTaskData{

    private TodoTask todo_task;

    isolated function init(int? id = 0,TodoTask? todo_task=null) returns error?{
        
        if(todo_task !=null){
          self.todo_task = todo_task.cloneReadOnly();
          return;
        }

        lock{

            TodoTask todo_task_raw;

            todo_task_raw = check db_client->queryRow(
                `SELECT *
                FROM todo_task
                WHERE id = ${id};`);
            

            self.todo_task = todo_task_raw.cloneReadOnly();

        }
   }

    isolated resource function get id() returns int?|error {
        lock {
            return self.todo_task.id;
        }
   }

    isolated resource function get task() returns string? {
        lock {
                return self.todo_task.task;
        }
   }

}
