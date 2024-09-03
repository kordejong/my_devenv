-- TODO:
-- - class_template
-- - member_function
-- - test_module
-- - test_case
-- - copy_constructor
-- - move_constructor
-- - copy_assignment_operator
-- - move_assignment_operator

return {
    s("class_header", fmt([[
#pragma once


namespace {a} {{

    class {b}
    {{

        public:

            {b}() = default;

            {b}({b} const&) = default;

            {b}({b}&&) = default;

            ~{b}() = default;

            auto operator=({b} const&) -> {b}& = default;

            auto operator=({b}&&) -> {b}& = default;

        private:

    }};

}}  // namespace {a}
    ]], {
        a = i(1, "namespace"),
        b = i(2, "class name"),
    },
    {
        repeat_duplicates = true,
    })),

    s("class_module", fmt([[
#include "{a}.hpp"


namespace {b} {{

    {c}::{c}()
    {{
    }}


    {c}::{c}({c} const& other)
    {{
    }}


    {c}::{c}({c}&& other)
    {{
    }}


    {c}::~{c}()
    {{
    }}


    auto {c}::operator=({c} const& other) -> {c}& 
    {{
    }}


    auto {c}::operator=({c}&& other) -> {c}& 
    {{
    }}

}}  // namespace {b}
    ]], {
        a = i(1, "header"),
        b = i(2, "namespace"),
        c = i(3, "class name"),
    },
    {
        repeat_duplicates = true,
    })),
}
