#!/usr/bin/env python

# -*- coding: utf-8 -*-

import unittest

from example.test.coverage_example.app import process_input


class TestApp(unittest.TestCase):
    """Test the mathematical operations app"""

    def setUp(self):
        """This runs before the test cases are executed"""
        self.a = 10
        self.b = 5

    def test_0010_add(self):
        """Test add operation"""
        result = process_input(self.a, self.b, "add")
        self.assertEqual(result, 15)

    def test_0020_sub(self):
        """Test subtract operation"""
        result = process_input(self.a, self.b, "subtract")
        self.assertEqual(result, 5)

    def tearDown(self) -> None:
        del self.a
        del self.b
