import ballerina/graphql;
import ballerina/sql;

service graphql:Service /graphql on new graphql:Listener(5000) {

    isolated resource function get person_by_digital_id(string? id) returns PersonData|error? {

        Person|error? personJwtId = check db_client->queryRow(
            `SELECT *
            FROM person
            WHERE digital_id = ${id};`
        );

        if(personJwtId is Person){
            return new((),0,personJwtId);
        }
        return error("Unable to find person by digital id");
    }

    resource function get todo_task_list() returns TodoTaskData[]|error {
        stream<TodoTask, error?> todo_task_list;
        
        lock {
            todo_task_list = db_client->query(
                `SELECT *
                FROM todo_task`
            );
        }

        TodoTaskData[] todoTaskDatas = [];

        check from TodoTask todo_task in todo_task_list
            do {
                TodoTaskData|error todoTaskData = new TodoTaskData(0,todo_task);
                if !(todoTaskData is error) {
                    todoTaskDatas.push(todoTaskData);
                }
            };

        check todo_task_list.close();
        return todoTaskDatas;

    }

    isolated resource function get todo_task_by_id(int id) returns TodoTaskData|error? {

        if(id >0 ){
          return new(id,());
        }
    
        return error("Unable to find todo task by id");
    }
   
    remote function add_todo_task(TodoTask todo_task) returns TodoTaskData|error? {
        
        sql:ExecutionResult res = check db_client->execute(
            `INSERT INTO todo_task (
                task
            ) VALUES (
                ${todo_task.task}
            );`
        );

        int|string? insert_id = res.lastInsertId;
        if !(insert_id is int) {
            return error("Unable to insert Todo Task");
        }

        return new (insert_id);
    }

    remote function update_todo_task(TodoTask todo_task) returns TodoTaskData|error? {
        int id =  todo_task.id ?: 0;
        if (id == 0) {
            return error("Unable to update Todo Task");
        }

        sql:ExecutionResult res = check db_client->execute(
            `UPDATE todo_task SET
                task = ${todo_task.task}
            WHERE id = ${id};`
        );

        if (res.affectedRowCount == sql:EXECUTION_FAILED) {
            return error("Unable to update Todo Task");
        }

        return new (id);
    }


    remote function delete_todo_task(int id) returns int?|error? {

        sql:ExecutionResult res = check db_client->execute(
            `DELETE FROM todo_task WHERE id = ${id};`
        );

        int? delete_id = res.affectedRowCount;
        if (delete_id <= 0) {
            return error("Unable to delete todo task with id: " + id.toString());
        }

        return delete_id;
    }

    

    
}