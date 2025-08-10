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

    // Write necessary attributes to store what type of symbol it is (variable/array/function)
    symbol_type sym_type;
    // Write necessary attributes to store the type/return type of the symbol (int/float/void/...)
    // Write necessary attributes to store the parameters of a function
    vector<symbol_info> parameters;
    // Write necessary attributes to store the array size if the symbol is an array
    int array_size = -1;

public:
    symbol_info(string name, string type, symbol_type sym_type = symbol_type::VARIABLE, vector<symbol_info> parameters = {}, int array_size = -1)
    {
        this->name = name;
        this->type = type;
        this->sym_type = sym_type;
        if (sym_type == symbol_type::FUNCTION)
        {
            this->parameters = parameters;
        }else if (sym_type == symbol_type::ARRAY)
        {
            this->array_size = array_size;
        }
    }

    string get_name()
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

    vector<symbol_info> get_parameters()
    {
        return parameters;
    }

    void set_parameters(vector<symbol_info> params)
    {
        this->parameters = params;
    }

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
        // Write necessary code to deallocate memory, if necessary
        parameters.clear();
    }
};