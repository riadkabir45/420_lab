#include "symbol_info.h"

class scope_table
{
private:
    int bucket_count;
    int unique_id;
    scope_table *parent_scope = NULL;
    vector<list<symbol_info *>> table;

    int hash_function(string name)
    {
        // write your hash function here
        int hash_value = 0;
        for (char c : name)
        {
            if (c >= 'A' && c <= 'Z')
                hash_value += ((int)c - (int)'A');
            else if (c >= 'a' && c <= 'z')
                hash_value += ((int)c - (int)'a' + 26);
            else if (c >= '0' && c <= '9')
                hash_value += ((int)c - (int)'0' + 52);
            else
                hash_value += (int)c;
        }
        return hash_value % bucket_count;
    }

public:
    scope_table();
    scope_table(int bucket_count, int unique_id, scope_table *parent_scope);
    scope_table *get_parent_scope();
    int get_unique_id();
    symbol_info *lookup_in_scope(symbol_info* symbol);
    bool insert_in_scope(symbol_info* symbol);
    bool delete_from_scope(symbol_info* symbol);
    void print_scope_table(ofstream& outlog);
    //~scope_table();

    // you can add more methods if you need
};

scope_table::scope_table(int bucket_count, int unique_id, scope_table *parent_scope)
{
    this->bucket_count = bucket_count;
    this->unique_id = unique_id;
    this->parent_scope = parent_scope;
    table.resize(bucket_count);
}


scope_table::scope_table() : scope_table(10, 0, NULL) { }

int scope_table::get_unique_id()
{
    return unique_id;
}

scope_table *scope_table::get_parent_scope()
{
    return parent_scope;
}

bool scope_table::insert_in_scope(symbol_info* symbol)
{
    int index = hash_function(symbol->getname());
    table[index].push_back(symbol);
    return true;
}

bool scope_table::delete_from_scope(symbol_info* symbol)
{
    int index = hash_function(symbol->getname());
    for (auto it = table[index].begin(); it != table[index].end(); ++it)
    {
        if ((*it)->getname() == symbol->getname())
        {
            table[index].erase(it);
            return true;
        }
    }
    return false;
}

symbol_info* scope_table::lookup_in_scope(symbol_info* symbol)
{
    int index = hash_function(symbol->getname());
    for (auto it = table[index].begin(); it != table[index].end(); ++it)
    {
        if ((*it)->getname() == symbol->getname())
        {
            return *it;
        }
    }
    return NULL;
}

// complete the methods of scope_table class
void scope_table::print_scope_table(ofstream& outlog)
{
    outlog << "ScopeTable # "+ to_string(unique_id) << endl;

    int counter = 0;
    for (auto bucket_it = table.begin(); bucket_it != table.end(); ++bucket_it)
    {
        if (!bucket_it->empty())
        {
            for (auto symbol : *bucket_it)
            {
                outlog << to_string(counter++) << " --> " << endl;
                outlog << "< " << symbol->getname() << " : ID >" << endl;

                if(symbol->is_variable())
                    outlog << "Variable" << endl;
                else if(symbol->is_array())
                    outlog << "Array" << endl;
                else if(symbol->is_function())
                    outlog << "Function Definition" << endl;


                if(symbol->is_function())
                {
                    outlog << "Return Type: " << symbol->get_type() << endl;
                    outlog << "Number of Parameters: " << symbol->get_parameters().size() << endl;
                    outlog << "Parameter Details: ";
                    bool first_param = true;
                    for(auto param : symbol->get_parameters())
                    {
                        if(first_param){
                            outlog << param->get_type() << " " << param->getname();
                            first_param = false;
                        }
                        else
                            outlog << ", " << param->get_type() << " " << param->getname();
                    }
                    outlog << endl;
                }else{
                    outlog << "Type: " << symbol->get_type() << endl;
                }
                if(symbol->is_array())
                    outlog << "Size: " << symbol->get_array_size() << endl;
            }
            outlog << endl;
        }
    }

    //iterate through the current scope table and print the symbols and all relevant information
}
