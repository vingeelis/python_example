import unittest
import xmlrunner


def runner_run():
    suite = unittest.TestSuite()
    all_cases = unittest.defaultTestLoader.discover('./', '*_test.py')
    for cases in all_cases:
        suite.addTests(cases)
    runner = xmlrunner.XMLTestRunner(output="report")  # output directory = "report"
    runner.run(suite)


def run_runner():
    from example.test.unittest_example import TestDict as unittest_example_TestDict
    from example.test import TestApp
    from example.test import TestDict as relatively_import_TestDict
    from example.test import TestStringMethods

    loader = unittest.TestLoader()
    all_cases = (unittest_example_TestDict, TestApp, relatively_import_TestDict, TestStringMethods)
    suite = unittest.TestSuite()
    for cases in all_cases:
        tests = loader.loadTestsFromTestCase(cases)
        suite.addTests(tests)
    runner = xmlrunner.XMLTestRunner(output="report")
    runner.run(suite)


if __name__ == '__main__':
    runner_run()
    # run_runner()