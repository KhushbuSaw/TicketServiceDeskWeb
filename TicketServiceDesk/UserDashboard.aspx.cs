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
    public partial class UserDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string email = Request.QueryString["email"];
                BindUserTicketsDetails(email);
            }
        }
        protected void BindUserTicketsDetails(string email)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string userDetailsQuery = "SELECT UserID FROM Users WHERE Email = @Email";
                SqlCommand getUserCommand = new SqlCommand(userDetailsQuery, con);
                getUserCommand.Parameters.AddWithValue("@Email", email);

                object result = getUserCommand.ExecuteScalar();

                if (result == null)
                {
                    return;
                }

                int userId = Convert.ToInt32(result);

                string query = @"
                SELECT TicketID, RaisedByUserName, RaisedByUserEmail, TicketType, Status, CreatedDate, DeliveryDate
                FROM Tickets
                WHERE AssignedToUserID = @AssignedToUserID";

                SqlCommand getTicketsCommand = new SqlCommand(query, con);
                getTicketsCommand.Parameters.AddWithValue("@AssignedToUserID", userId);

                SqlDataAdapter da = new SqlDataAdapter(getTicketsCommand);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTickets.DataSource = dt;
                gvTickets.DataBind();
            }
        }

        protected void gvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}