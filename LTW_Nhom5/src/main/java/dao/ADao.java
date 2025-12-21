package dao;
// tạo ket noi de cac thang nho hon ke thua

import db.JdbiConnector;
import org.jdbi.v3.core.Jdbi;

public abstract class ADao {
    protected Jdbi jdbi = JdbiConnector.get();
}

