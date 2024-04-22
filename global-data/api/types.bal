public type Person record {|
    readonly string? record_type = "person";
    int id?;
    string? full_name;
    string? asgardeo_id;
    string? jwt_sub_id;
    string? jwt_email;
    string? digital_id;
    string? email;
    string? created;
    string? updated;
|};

public type TodoTask record{
    readonly string? record_type = "todo_task";
    int id?;
    string?  task;
};