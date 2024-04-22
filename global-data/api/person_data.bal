

public isolated service class PersonData {
    private Person person;

    isolated function init(string? name = null, int? person_id = 0, Person? person = null) returns error? {
        if(person != null) { // if person is provided, then use that and do not load from DB
            self.person = person.cloneReadOnly();
            return;
        }

        string _name = "%" + (name ?: "") + "%";
        int id = person_id ?: 0;

        Person person_raw;
        if(id > 0) { // organization_id provided, give precedance to that
            person_raw = check db_client -> queryRow(
            `SELECT *
            FROM person
            WHERE
                id = ${id};`);
        } else 
        {
            person_raw = check db_client -> queryRow(
            `SELECT *
            FROM person
            WHERE
                preferred_name LIKE ${_name};`);
        }
        
        self.person = person_raw.cloneReadOnly();
    }

    isolated resource function get id() returns int? {
        lock {
                return self.person.id;
        }
    }

    isolated resource function get full_name() returns string?{
        lock {
            return self.person.full_name;
        }
    }

   
    isolated resource function get created() returns string?{
        lock {
            return self.person.created;
        }
    }

    isolated resource function get updated() returns string?{
        lock {
            return self.person.updated;
        }
    }

    
    isolated resource function get asgardeo_id() returns string?{
        lock {
            return self.person.asgardeo_id;
        }
    }

    isolated resource function get jwt_sub_id() returns string?{
        lock {
            return self.person.jwt_sub_id;
        }
    }

    isolated resource function get jwt_email() returns string?{
        lock {
            return self.person.jwt_email;
        }
    }

    isolated resource function get digital_id() returns string?{
        lock {
            return self.person.digital_id;
        }
    }

    isolated resource function get email() returns string?{
        lock {
            return self.person.email;
        }
    }
}
