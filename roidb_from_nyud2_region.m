function roidb = roidb_from_nyud2_region(imdb)

  imdb_name = imdb.name;
  image_ids = imdb.image_ids;
  cls_to_id = imdb.cls_to_id;
  num_classes = imdb.num_classes;
  regionDir = imdb.regionDir;

  parfor i = 1:length(image_ids)
    tic_toc_print('roidb (%s): %d/%d\n', imdb_name, i, length(image_ids));
    
    % Load the ground truth annotations
    rec = getGroundTruthBoxes(imdb, i); 

    % Load the boxes
    dt = load(fullfile_ext(regionDir, image_ids{i}, 'mat'), 'bboxes', 'superpixels', 'sp2reg');
    dt.bboxes = dt.bboxes(1:min(imdb.max_boxes, size(dt.bboxes,1)), [2 1 4 3]);
    dt.sp2reg = dt.sp2reg(1:min(imdb.max_boxes, size(dt.bboxes,1)), :);
   
    % Attach the regions
    rois(i) = attach_proposals_region(rec, dt, cls_to_id, num_classes);
  end
  
  roidb.rois = rois;
end
