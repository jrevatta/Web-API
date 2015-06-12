using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using WebclonUrbania.Models;

namespace WebclonUrbania.Controllers
{
    public class ContactoController : ApiController {

        private Model db = new Model();


        // GET: api/Contacto
        public IEnumerable<ContactoDTO> GetContacto()
        {

            IQueryable<Contacto> contactos = db.Contacto;
            ContactoDTO element = new ContactoDTO();
            List<ContactoDTO> contactosAPI = new List<ContactoDTO>();


            foreach (Contacto e in contactos)
            {
                element.contactoId = e.contactoId;
                element.nombre = e.nombre;
                element.apellido = e.apellido;
                element.email = e.email;
                element.telefono = e.telefono;
                contactosAPI.Add(element);
                element = new ContactoDTO();


            }
            return contactosAPI;

        }

        // GET: api/Contacto/10005
        [ResponseType(typeof(ContactoDTO))]
        public IHttpActionResult GetContacto(int id)
        {
            Contacto contacto = db.Contacto.Find(id);

            ContactoDTO element = new ContactoDTO();

            if (contacto == null)
            {
                return NotFound();
            }

            element.contactoId = contacto.contactoId;
            element.nombre = contacto.nombre;
            element.apellido = contacto.apellido;
            element.email = contacto.email;
            element.telefono = contacto.telefono;

            return Ok(element);
        }


    }
}
