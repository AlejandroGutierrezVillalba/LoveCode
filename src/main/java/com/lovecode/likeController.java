package com.lovecode;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/likes")
public class likeController {

    private final likeDAO likeDAO = new likeDAO();

    @PostMapping
    public String registrarLike(@RequestParam int idOrigen, @RequestParam int idDestino) {
        return likeDAO.registrarLike(idOrigen, idDestino);
    }

    @GetMapping("/dados/{idUsuario}")
    public List<Integer> obtenerLikesDados(@PathVariable int idUsuario) {
    return likeDAO.obtenerLikesDados(idUsuario);
    }
}