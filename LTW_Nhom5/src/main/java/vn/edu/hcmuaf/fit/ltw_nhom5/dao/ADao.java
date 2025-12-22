package vn.edu.hcmuaf.fit.ltw_nhom5.dao;
// tạo ket noi de cac thang nho hon ke thua

import vn.edu.hcmuaf.fit.ltw_nhom5.db.JdbiConnector;
import org.jdbi.v3.core.Jdbi;

public abstract class ADao {
    protected Jdbi jdbi = JdbiConnector.get();
}

