package com.lovecode;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/usuarios")
public class usuarioController {

    private final usuarioDAO usuarioDAO = new usuarioDAO();

    @GetMapping
    public List<usuario> obtenerTodos() {
        return usuarioDAO.obtenerTodos();
    }

    @PostMapping("/registro")
    public String registrar(@RequestBody usuario usuario) {
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
        if (u != null) {
            return "OK:" + u.getIdUsuario() + ":" + u.getNombre();
        } else {
            return "Email o contrasena incorrectos";
        }
    }
}