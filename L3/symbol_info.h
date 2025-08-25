#include<bits/stdc++.h>
using namespace std;

enum class symbol_type
{
    VARIABLE,
    ARRAY,
    FUNCTION
};

class symbol_info
{
private:
    string name;
    string type;
    symbol_type sym_type;
    // Change to list of pointers
    list<symbol_info*> parameters;
    int array_size = -1;

public:
    // Update constructor
    symbol_info(string name, string type, symbol_type sym_type = symbol_type::VARIABLE, list<symbol_info*> parameters = {}, int array_size = -1)
    {
        this->name = name;
        this->type = type;
        this->sym_type = sym_type;
        if (sym_type == symbol_type::FUNCTION)
        {
            this->parameters = parameters;
        } else if (sym_type == symbol_type::ARRAY)
        {
            this->array_size = array_size;
        }
    }

    string getname()
    {
        return name;
    }

    string get_type()
    {
        return type;
    }

    void set_name(string name)
    {
        this->name = name;
    }

    void set_type(string type)
    {
        this->type = type;
    }

    // Write necessary functions to set and get the attributes
    symbol_type get_symbol_type()
    {
        return sym_type;
    }

    void set_symbol_type(symbol_type type)
    {
        this->sym_type = type;
    }

    // Update getters and setters
    list<symbol_info*> get_parameters() { return parameters; }
    void set_parameters(list<symbol_info*> params) { parameters = params; }
    void add_parameter(symbol_info* param) { parameters.push_back(param); }

    int get_array_size()
    {
        return array_size;
    }

    void set_array_size(int size)
    {
        this->array_size = size;
    }

    bool is_variable()
    {
        return sym_type == symbol_type::VARIABLE;
    }

    bool is_array()
    {
        return sym_type == symbol_type::ARRAY;
    }

    bool is_function()
    {
        return sym_type == symbol_type::FUNCTION;
    }

    ~symbol_info()
    {
        // If you own the pointers, delete them here
        for (auto ptr : parameters) {
            delete ptr;
        }
        parameters.clear();
    }

    
    bool compare(symbol_info* sym){
    if(sym->getname() == this->getname()){
        return true;
    }
    return false;
}
};