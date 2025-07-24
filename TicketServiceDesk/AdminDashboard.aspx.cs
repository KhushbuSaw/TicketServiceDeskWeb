using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TicketServiceDesk
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTicketSummary();
            }

        }
        private void LoadTicketSummary()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                SELECT Status, COUNT(*) AS TicketCount
                FROM Tickets
                GROUP BY Status
                ORDER BY 
                  CASE 
                    WHEN Status = 'Open' THEN 1
                    WHEN Status = 'Work-in-progress' THEN 2
                    WHEN Status = 'Resolved' THEN 3
                    WHEN Status = 'Closed' THEN 4
                    ELSE 5
                  END";
               // string query = "SELECT Status, COUNT(*) AS TicketCount FROM Tickets GROUP BY Status";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }

        }
    }
}