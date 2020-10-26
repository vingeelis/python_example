def calculate_safe_max_down_per_column(svcinst):
    n_nodes_in_column = {}
    for i in svcinst:
        s = i.split('-')
        if len(s) < 4:
            return 0
        column = '-'.join(s[:-1])
        if column not in n_nodes_in_column:
            n_nodes_in_column[column] = 1
        else:
            n_nodes_in_column[column] += 1
    percent = 0.15
    max_down_per_column = int(list(n_nodes_in_column.values())[0] * percent) + 1
    for i in n_nodes_in_column.values():
        safe = int(i * percent) + 1
        if max_down_per_column > safe:
            max_down_per_column = safe
    return max_down_per_column


svcinsts = """
completed-lla-lvs-001-001
completed-lla-lvs-001-002
completed-lla-lvs-001-003
completed-lla-lvs-001-004
completed-lla-lvs-001-005
completed-lla-lvs-001-006
completed-lla-lvs-001-007
completed-lla-lvs-001-008
completed-lla-lvs-001-009
completed-lla-lvs-001-010
completed-lla-lvs-001-011
completed-lla-lvs-001-012
completed-lla-lvs-001-013
completed-lla-lvs-001-014
completed-lla-lvs-001-015
completed-lla-lvs-001-016
completed-lla-lvs-001-017
completed-lla-lvs-001-018
completed-lla-lvs-001-019
completed-lla-lvs-001-020
completed-lla-lvs-001-021
completed-lla-lvs-001-022
""".split()

print(calculate_safe_max_down_per_column(svcinsts))
