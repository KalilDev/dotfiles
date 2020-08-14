#include <nlohmann/json.hpp>
#include <boost/optional.hpp>
#include <boost/program_options.hpp>
#include <iostream>

using json = nlohmann::json;

namespace po = boost::program_options;

typedef bool testFunc(json json);

bool isFocused(json json)
{
    auto it_focused = json.find("focused");
    if (it_focused == json.end())
    {
        return false;
    }
    auto focused = *it_focused;
    if (!focused.is_boolean())
    {
        return false;
    }
    return focused.get<bool>();
}

boost::optional<json> get_node_recursive(json root, testFunc *test)
{
    // Root needs to be an node
    if (!root.is_object())
    {
        return boost::none;
    }

    // Check if the root node passes the test.
    if (test(root))
    {
        return boost::optional<json>(root);
    }

    auto it_children = root.find("nodes");
    if (it_children == root.end())
    {
        // Node does not contain children
        return boost::none;
    }

    auto children = *it_children;
    if (!children.is_array())
    {
        // Children is not an array
        return boost::none;
    }
    for (json::iterator it = children.begin(); it != children.end(); ++it)
    {
        auto child = *it;
        auto maybePassed = get_node_recursive(child, test);
        if (maybePassed != boost::none)
        {
            return maybePassed;
        }
    }
    return boost::none;
}
const char rect[] = "rect";
constexpr bool isSlurp(const int argc, const char *argv[])
{
    if (argc < 2)
    {
        return false;
    }
    return std::strcmp(argv[1], "slurp-rect") == 0;
}

int main(const int argc, const char *argv[])
{
    // If specified, only this key will be returned from the focused window.
    // (If there is one)
    const char *requestedKey = nullptr;
    if (argc >= 2)
    {
        requestedKey = isSlurp(argc, argv) ? rect : argv[1];
    }

    json nodes;
    std::cin >> nodes;
    auto maybe_focused = get_node_recursive(nodes, isFocused);
    if (maybe_focused == boost::none)
    {
        std::cerr << "Couldn't find an focused node" << std::endl;
        return 1;
    }

    auto focused = maybe_focused.get();

    // Output the whole object
    if (requestedKey == nullptr)
    {
        std::cout << focused << std::endl;
        return 1;
    }

    auto objectKey = focused.find(requestedKey);
    if (objectKey == focused.end())
    {
        std::cerr << "Coudn't find key \"" << requestedKey << "\" on the focused object" << std::endl;
        return 1;
    }

    // There is an special case for an slurp-like rect
    if (isSlurp(argc, argv))
    {
        auto rect = *objectKey;
        std::cout << rect["x"] << ',' << rect["y"] << ' ' << rect["width"] << "x" << rect["height"] << std::endl;
        return 0;
    }

    std::cout << *objectKey << std::endl;
    return 0;
}