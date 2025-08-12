#include "scope_table.h"

class symbol_table
{
private:
    scope_table *current_scope;
    int bucket_count;
    int current_scope_id;

public:
    symbol_table(int bucket_count);
    ~symbol_table();
    void enter_scope();
    void exit_scope();
    bool insert(symbol_info* symbol);
    symbol_info* lookup(symbol_info* symbol);
    void print_current_scope(ofstream& outlog);
    void print_all_scopes(ofstream& outlog);

    // you can add more methods if you need 
    int get_current_scope_id();
};

// complete the methods of symbol_table class

int symbol_table::get_current_scope_id()
{
    return current_scope_id;
}

symbol_table::symbol_table(int bucket_count)
{
    this->bucket_count = bucket_count;
    this->current_scope_id = 1;
    current_scope = new scope_table(bucket_count, current_scope_id, NULL);
}

void symbol_table::enter_scope()
{
    current_scope_id++;
    scope_table *new_scope = new scope_table(bucket_count, current_scope_id, current_scope);
    current_scope = new_scope;
}

void symbol_table::exit_scope()
{
    if (current_scope != NULL)
    {
        scope_table *temp = current_scope;
        current_scope = current_scope->get_parent_scope();
        delete temp;
        current_scope_id--;
    }
}

bool symbol_table::insert(symbol_info* symbol)
{
    if (current_scope != NULL)
    {
        return current_scope->insert_in_scope(symbol);
    }
    return false;
}

symbol_info* symbol_table::lookup(symbol_info* symbol)
{
    scope_table *temp = current_scope;
    while (temp != NULL)
    {
        symbol_info *found_symbol = temp->lookup_in_scope(symbol);
        if (found_symbol != NULL)
        {
            return found_symbol;
        }
        temp = temp->get_parent_scope();
    }
    return NULL;
}

void symbol_table::print_current_scope(ofstream& outlog)
{
    outlog << "################################" << endl << endl;
    current_scope->print_scope_table(outlog);
    outlog << "################################" << endl << endl;
}

void symbol_table::print_all_scopes(ofstream& outlog)
{
    outlog<<"################################"<<endl<<endl;
    scope_table *temp = current_scope;
    while (temp != NULL)
    {
        temp->print_scope_table(outlog);
        if(temp->get_parent_scope() != NULL)
            outlog << endl;
        temp = temp->get_parent_scope();
    }
    outlog<<"################################"<<endl<<endl;
}