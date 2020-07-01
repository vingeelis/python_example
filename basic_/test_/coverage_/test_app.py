#!/usr/bin/env python

# -*- coding: utf-8 -*-

import unittest

from basic_.test_.src.app import process_input


class TestApp(unittest.TestCase):
    """Test the mathematical operations app"""

    def setUp(self):
        """This runs before the test cases are executed"""
        self.a = 10
        self.b = 5

    def test_add(self):
        """Test add operation"""
        result = process_input(self.a, self.b, "add")
        self.assertEqual(result, 15)

    def test_subtract(self):
        """Test subtract operation"""
        result = process_input(self.a, self.b, "subtract")
        self.assertEqual(result, 5)

    def test_multiple(self):
        """Test multiple operation"""
        result = process_input(self.a, self.b, "multiple")
        self.assertEqual(result, 150)

    def test_divide(self):
        """Test divide operation"""

        result = process_input(self.a, 0, "divide")
        self.assertEqual(result, "InvalidInput")

        result = process_input(self.a, self.b, "divide")
        self.assertEqual(result, 2)

    def tearDown(self) -> None:
        del self.a
        del self.b


def suite():
    """Test suite"""
    suite = unittest.TestSuite()
    suite.addTests(
        unittest.TestLoader().loadTestsFromTestCase(TestApp)
    )
    return suite


if __name__ == '__main__':
    unittest.TextTestRunner(verbosity=2).run(suite())
