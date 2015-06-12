namespace WebclonUrbania.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Tipo_Inmueble
    {
        public Tipo_Inmueble()
        {
            Inmueble = new HashSet<Inmueble>();
        }

        [Key]
        public int tipoInmId { get; set; }

        [StringLength(50)]
        public string descripcion { get; set; }

        public virtual ICollection<Inmueble> Inmueble { get; set; }
    }
}
