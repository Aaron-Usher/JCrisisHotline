/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import Accessors.UserAccessor;
import Beans.User;
import Beans.UserPageBean;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * This Servlet uses a user attribute and switch structure to handle various
 * requests
 * @author DragonSheep
 * 
 * Updated: 2017/04/18 By: Alissa Duffy Standardized Commenting.
 */
public class UserListHandler extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserPageBean pageBean = new UserPageBean();
        try {
            if(null!=request.getParameter("submit")) {
                User toSave = new User(
                    Integer.parseInt((String)request.getParameter("id")),
                    (String)request.getParameter("username"),
                    (String)request.getParameter("firstName"),
                    (String)request.getParameter("lastName"),
                    (String)request.getParameter("phone"),
                    (String)request.getParameter("addressOne"),
                    (String)request.getParameter("addressTwo"),
                    (String)request.getParameter("city"),
                    (String)request.getParameter("territory"),
                    (String)request.getParameter("zip")
                );
                toSave.validate();
                if(!toSave.isValid()) {
                    request.setAttribute("message", "Invalid inputs");
                    request.getRequestDispatcher("Users.jsp").forward(request, response);
                    return;
                }
                
                UserAccessor.updateUser(toSave);
                UserAccessor.updateUserRoles(
                        toSave.getID(),
                        null!=request.getParameter("isReports"),
                        null!=request.getParameter("isCounselor"),
                        null!=request.getParameter("isManager"),
                        null!=request.getParameter("isDataEntry")
                );
            }
            ArrayList<User> userList = UserAccessor.getUserList();
            pageBean.setUserList(userList);
            User currentUser = (User) session.getAttribute("user");
            if(null!=currentUser) {
                pageBean.setRoles(
                    UserAccessor.retrieveUserRoles(currentUser.getID())
                );
            }
            for(User listedUser:userList) {
                listedUser.setRoles(
                        UserAccessor.retrieveUserRoles(listedUser.getID())
                );
            }
        } catch (SQLException ex) {
            pageBean.setErrorMessage("Internal error: " + ex.getMessage());
        }
        session.setAttribute("pageBean", pageBean);
        request.getRequestDispatcher("Users.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
