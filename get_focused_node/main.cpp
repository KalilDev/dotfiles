#include <nlohmann/json.hpp>
#include <boost/optional.hpp>
#include <boost/program_options.hpp>
#include <iostream>
#include <string>

using json = nlohmann::json;

namespace po = boost::program_options;

bool is_focused(json json)
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

typedef bool testFunc(json json);

boost::optional<json> get_node_recursive(json root, testFunc *test, bool get_parents)
{
    // Root needs to be an node
    if (!root.is_object())
    {
        return boost::none;
    }

    // Check if root passes the test.
    if (test(root))
    {
        return boost::optional<json>(root);
    }

    // These keys may contain children
    std::vector<json::iterator> children_iterators = {root.find("nodes"), root.find("floating_nodes")};

    boost::optional<json> result = boost::none;
    for (auto it_children : children_iterators)
    {
        // Skip if the iterator is empty
        if (it_children == root.end())
        {
            continue;
        }
        auto children = *it_children;

        // Children should be an array of nodes
        if (!children.is_array())
        {
            continue;
        }

        // Walk down the children recursively until an node that passes the test is
        // found
        std::vector<int> to_remove;
        for (auto &it : children.items())
        {
            auto child = it.value();
            auto maybe_passed = get_node_recursive(child, test, get_parents);
            
            // Boom, found it
            if (maybe_passed != boost::none)
            {
                if (!get_parents) {
                    return maybe_passed;
                }
                result = maybe_passed;
            } else {
                to_remove.push_back(stoi(it.key()));
            }
        }

        // Iterate backwards to remove the nodes that aren't used
        std::sort(to_remove.rbegin(), to_remove.rend());
        for (int &it : to_remove) {
            children.erase(it);
        }

    }
    // Couldn't find a node that satisfies the test
    if (result == boost::none) {
        return boost::none;
    }

    // An child satisfied the test
    return root;
}

static const std::string help_message =
    "This program takes an sway tree (or any json tree that consists of\n\
objects with an \"nodes\" array), and runs an test (normally checks\n\
if the \"focused\" key is true). The output can then be transformed.\n\
Options";

int main(const int argc, const char *argv[])
{
    try
    {
        // Parse all the options
        bool slurp = false;
        bool raw = false;
        bool get_parents = false;
        po::options_description desc{help_message};
        desc.add_options()("help,h", "Help screen")
        ("slurp,s", po::bool_switch(&slurp), "Output the node's \"rect\" in an slurp-like manner.")
        ("raw,r", po::bool_switch(&raw), "Output the node's raw json representation.")
        ("key,k", po::value<std::string>(), "Output the selected key (if it exists on the node)")
        ("parents,p", po::bool_switch(&get_parents), "Output not only the node but also it's parents (sanitized).");

        po::variables_map vm;
        store(parse_command_line(argc, argv, desc), vm);
        po::notify(vm);

        // Output the help
        if (vm.count("help"))
        {
            std::cout << desc << std::endl;
            return 0;
        }

        // Parse the json from stdin
        json nodes;
        std::cin >> nodes;

        // Find the node which satisfies the test
        auto maybe_focused = get_node_recursive(nodes, is_focused, get_parents);

        // Exit when none do
        if (maybe_focused == boost::none)
        {
            std::cerr << "Couldn't find an focused node" << std::endl;
            return 1;
        }

        // Output the resulting node according to the user option
        auto focused = maybe_focused.get();

        // The whole node
        if (raw)
        {
            std::cout << focused << std::endl;
            return 0;
        }

        // Slurp-like formatter "rect" object
        if (slurp)
        {
            auto it_rect = focused.find("rect");
            if (it_rect == focused.end())
            {
                std::cerr << "Node missing the \"rect\" object" << std::endl;
                return 1;
            }
            auto rect = *it_rect;
            std::cout << rect["x"] << ',' << rect["y"] << ' ' << rect["width"] << "x" << rect["height"] << std::endl;
            return 0;
        }

        // Node's key
        if (vm.count("key"))
        {
            auto key = vm["key"].as<std::string>();
            auto it_value = focused.find(key);
            if (it_value == focused.end())
            {
                std::cerr << "Node does not contain the key \"" << key << "\"" << std::endl;
                return 1;
            }
            std::cout << *it_value << std::endl;
            return 0;
        }

        // Error when the user did not specify any output format
        std::cerr << "No output format was specified!" << std::endl;
        return 1;
    }
    catch (const po::error &ex)
    {
        std::cerr << ex.what() << '\n';
        return 1;
    }
}
