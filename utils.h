#pragma once

#include <regex>
#include <string>
#include <vector>


/// Парсит строку, выделяя из нее слова на базе регулярного выражения.
/// Возвращает коллекцию выделенных слов.
inline std::vector<std::string> extractWords(const std::string line, const std::regex regex)
{
    using namespace std;

    vector<string> result;

    sregex_token_iterator it(line.begin(), line.end(), regex, -1);
    const sregex_token_iterator itEnd;

    for (; it != itEnd; ++it)
    {
        if (it->str().empty())
            continue;

        result.emplace_back(it->str());
    }

    return result;
}
