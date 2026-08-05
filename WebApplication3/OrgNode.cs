using System.Collections.Generic;

namespace HRMSApp
{
    public class OrgNode
    {
        public int OrgRoleID;
        public string RoleTitle;
        public int? EmpID;
        public string EmpName;
        public string Designation;
        public List<OrgNode> Children = new List<OrgNode>();
    }
}