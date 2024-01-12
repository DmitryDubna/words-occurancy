#pragma once

#include <regex>
#include <string>
#include <vector>

inline std::vector<std::string> extractWords(const std::string str, const std::regex regex = std::regex("[\\s,]+"))
{
    using namespace std;

    vector<string> result;

    sregex_token_iterator it( str.begin(), str.end(), regex, -1 );
    const sregex_token_iterator reg_end;

    for ( ; it != reg_end; ++it )
    {
        if (!it->str().empty()) //token could be empty:check
            result.emplace_back( it->str() );
    }

    return result;
}


