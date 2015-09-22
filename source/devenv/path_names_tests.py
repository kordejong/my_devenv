import unittest
import path_names


class PathNameTests(unittest.TestCase):

    def test_path_name_components(self):
        self.assertEqual(path_names.path_name_components("/home/kor"),
            ["/", "home", "kor"])
        self.assertEqual(path_names.path_name_components("home/kor"),
            ["home", "kor"])
        self.assertEqual(path_names.path_name_components("../home/kor"),
            ["..", "home", "kor"])
        self.assertEqual(path_names.path_name_components(""), [])
        self.assertEqual(path_names.path_name_components("/"), ["/"])
        self.assertEqual(path_names.path_name_components("/"), ["/"])


if __name__ == "__main__":
    unittest.main()
