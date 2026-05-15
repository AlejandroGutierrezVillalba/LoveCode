package com.lovecode;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/usuarios")
public class usuarioController {

    private final usuarioDAO usuarioDAO = new usuarioDAO();

    @GetMapping
    public List<usuario> obtenerTodos(@RequestParam(required = false) Integer excluir) {
        return usuarioDAO.obtenerTodos(excluir);
    }

    @GetMapping("/{id}")
    public String cargarDatos(@PathVariable int id) {
        return usuarioDAO.cargarDatosUsuario(id);
    }

    @DeleteMapping("/{id}")
    public String borrarUsuario(@PathVariable int id) {
        return usuarioDAO.borrarUsuario(id);
    }

    @PutMapping("/{id}/reactivar")
    public String reactivarUsuario(@PathVariable int id) {
        return usuarioDAO.reactivarUsuario(id);
    }

    @PostMapping("/registro")
    public String registrar(@RequestBody usuario usuario) {
        String error = validaciones.validarUsuario(usuario);
        if (error != null) {
            return "ERROR:" + error;
        }
        int id = usuarioDAO.registrar(usuario);
        if (id > 0) {
            return "OK:" + id;
        } else {
            return "Error al registrar el usuario";
        }
    }

    @PostMapping("/login")
    public String login(@RequestBody usuario usuario) {
        usuario u = usuarioDAO.login(usuario.getEmail(), usuario.getPassword());
        if (u == null) {
            return "Email o contrasena incorrectos";
        }
        if (u.getActivo() == 0) {
            return "INACTIVO:" + u.getIdUsuario();
        }
        return "OK:" + u.getIdUsuario() + ":" + u.getNombre();
    }
}