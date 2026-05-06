package com.lovecode;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/likes")
public class likeController {

    private final likeDAO likeDAO = new likeDAO();

    @PostMapping
    public String registrarLike(@RequestParam int idOrigen, @RequestParam int idDestino) {
        return likeDAO.registrarLike(idOrigen, idDestino);
    }
}