using System;
using System.Collections.Generic;

//la clase ContactoDTO.cs

namespace WebclonUrbania.Models
{
    public class ContactoDTO
    {
        public ContactoDTO()
        {
        }

        public int contactoId { get; set; }
        public string nombre { get; set; }
        public string apellido { get; set; }
        public string email { get; set; }
        public string telefono { get; set; }
    }
}