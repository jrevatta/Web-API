using System;
using System.Collections.Generic;

//la clase InmuebleDTO.cs

namespace WebclonUrbania.Models
{
    public class InmuebleDTO
    {

        public InmuebleDTO()
        {
        }

        public int? contactoId { get; set; }

        public int inmId { get; set; }

        public string descripcion { get; set; }

        public int? habitacion { get; set; }

        public decimal? banio { get; set; }

        public int? antiguedad { get; set; }

        public int? area_terreno { get; set; }

        public int? area_construida { get; set; }


    }
}