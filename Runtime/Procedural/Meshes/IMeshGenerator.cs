using UnityEngine;

namespace SF.Procedural
{
    /// <summary>
    /// Defines the code to be executed by a C# job that generates a mesh.
    /// </summary>
    public interface IMeshGenerator
    {
        int VertexCount { get; }
        int IndexCount { get; }
        
        //The axis align bounds of the mesh being generated.
        Bounds Bounds { get; } 
        
        /// <summary>
        /// The length of the job to be injected into the scheduler.
        /// </summary>
        int JobLength { get; }
        
        int Resolution { get; set; }
        
        void Execute<S>(int index, S streams) where S : struct, IMeshStreams;
    }
}
