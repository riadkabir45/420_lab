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
    symbol_info* checkExists(symbol_info* symbol);
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
    int bucket_num = 0;

    for (auto bucket_it = table.begin(); bucket_it != table.end(); ++bucket_it,bucket_num++)
    {
        bool last_was_function = false;
        if (!bucket_it->empty())
        {
            outlog << to_string(bucket_num) << " --> " << endl;
            for (auto symbol : *bucket_it)
            {
                if(last_was_function && symbol->is_function()){
                    outlog << endl;
                }else{
                    last_was_function = false;
                }
                outlog << "< " << symbol->getname() << " : ID >" << endl;

                if(symbol->is_variable())
                    outlog << "Variable";
                else if(symbol->is_array())
                    outlog << "Array";
                else if(symbol->is_function())
                    outlog << "Function Definition";

                outlog << endl;


                if(symbol->is_function())
                {
                    last_was_function = true;
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
                }else{
                    if(symbol->is_variable() && symbol->get_type() == "void")
                        outlog << "Type: " << "error";
                    else
                        outlog << "Type: " << symbol->get_type();
                }
                if(symbol->is_array())
                    outlog << endl;
                if(symbol->is_array())
                    outlog << "Size: " << symbol->get_array_size();
                
                if(!symbol->is_function())
                    outlog << endl;
            }
            outlog << endl;
        }
    }

    //iterate through the current scope table and print the symbols and all relevant information
}

symbol_info* scope_table::checkExists(symbol_info* symbol)
{
    int index = hash_function(symbol->getname());
    for (auto it = table[index].begin(); it != table[index].end(); ++it)
    {
        if ((*it)->compare(symbol))
        {
            return *it;
        }
    }
    return NULL;
}
