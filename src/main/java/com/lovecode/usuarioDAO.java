package com.lovecode;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

public class usuarioDAO {

    public int registrar(usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, email, password, descripcion, ciudad) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            String passwordHash = BCrypt.hashpw(usuario.getPassword(), BCrypt.gensalt());
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, passwordHash);
            ps.setString(4, usuario.getDescripcion());
            ps.setString(5, usuario.getCiudad());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
        }
        return -1;
    }

    public usuario login(String email, String password) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        String sqlHistorial = "INSERT INTO login_historial (id_usuario, email_intento, resultado) VALUES (?, ?, ?)";

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashGuardado = rs.getString("password");
                if (BCrypt.checkpw(password, hashGuardado)) {

                    if (rs.getInt("activo") == 0) {
                        usuario u = new usuario();
                        u.setIdUsuario(rs.getInt("id_usuario"));
                        u.setActivo(0);
                        return u;
                    }

                    usuario u = new usuario();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setNombre(rs.getString("nombre"));
                    u.setEmail(rs.getString("email"));
                    u.setDescripcion(rs.getString("descripcion"));
                    u.setCiudad(rs.getString("ciudad"));
                    u.setFechaRegistro(rs.getString("fecha_registro"));
                    u.setActivo(1);

                    try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                        psH.setInt(1, u.getIdUsuario());
                        psH.setString(2, email);
                        psH.setString(3, "exito");
                        psH.executeUpdate();
                    }
                    return u;
                }
            }

            try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                psH.setNull(1, java.sql.Types.INTEGER);
                psH.setString(2, email);
                psH.setString(3, "fallo");
                psH.executeUpdate();
            }

        } catch (SQLException e) {
            System.err.println("Error en login: " + e.getMessage());
        }
        return null;
    }

    public List<usuario> obtenerTodos(Integer excluirId) {
        List<usuario> lista = new ArrayList<>();
        String sql = excluirId != null
            ? "SELECT * FROM usuarios WHERE activo = 1 AND id_usuario != ?"
            : "SELECT * FROM usuarios WHERE activo = 1";

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (excluirId != null) ps.setInt(1, excluirId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                usuario u = new usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setDescripcion(rs.getString("descripcion"));
                u.setCiudad(rs.getString("ciudad"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                lista.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuarios: " + e.getMessage());
        }
        return lista;
    }

    public String cargarDatosUsuario(int idUsuario) {
        String sql = "{CALL pa_cargar_datos_usuario(?)}";
        StringBuilder resultado = new StringBuilder();

        try (Connection con = conexion.getConexion();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, idUsuario);
            boolean tieneResultados = cs.execute();

            while (tieneResultados) {
                ResultSet rs = cs.getResultSet();
                while (rs.next()) {
                    int cols = rs.getMetaData().getColumnCount();
                    for (int i = 1; i <= cols; i++) {
                        resultado.append(rs.getMetaData().getColumnName(i))
                                 .append(": ")
                                 .append(rs.getString(i))
                                 .append(" | ");
                    }
                    resultado.append("\n");
                }
                tieneResultados = cs.getMoreResults();
            }

        } catch (SQLException e) {
            System.err.println("Error al cargar datos usuario: " + e.getMessage());
        }
        return resultado.toString();
    }

    public String borrarUsuario(int idUsuario) {
        String sql = "{CALL pa_borrar_usuario(?)}";
        try (Connection con = conexion.getConexion();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, idUsuario);
            cs.execute();
            return "Usuario desactivado correctamente";

        } catch (SQLException e) {
            return "Error: " + e.getMessage();
        }
    }

    public String reactivarUsuario(int idUsuario) {
        String sql = "UPDATE usuarios SET activo = 1 WHERE id_usuario = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            return "OK";

        } catch (SQLException e) {
            System.err.println("Error al reactivar usuario: " + e.getMessage());
            return "ERROR";
        }
    }
}