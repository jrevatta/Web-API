namespace WebclonUrbania.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Contacto")]
    public partial class Contacto
    {
        public Contacto()
        {
            Inmueble = new HashSet<Inmueble>();
        }

        public int contactoId { get; set; }

        [StringLength(30)]
        public string nombre { get; set; }

        [StringLength(30)]
        public string apellido { get; set; }

        [StringLength(30)]
        public string email { get; set; }

        [StringLength(15)]
        public string telefono { get; set; }

        public virtual ICollection<Inmueble> Inmueble { get; set; }
    }
}
